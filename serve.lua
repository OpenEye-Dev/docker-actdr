-- load the required lua models
local torch = require("torch")
local nn = require("nn")
local gm = require "graphicsmagick"
local model = torch.load("prod_model.t7")
local image = require("image")

local img_size = 512
local num_transforms = 4

local generateTransformer = function()
  -- generate a transform function based on some other stuff
  -- normalize and add color jitter/ geometric transforms
  local T = require('transforms')
  local transforms = {}

  -- make deterministic becasue want to track down saliency
  -- perhaps add known transformations in the future
  transforms[1] = T.Scale(img_size)
  transforms[2] = T.Rotation(360)
  transforms[3] = T.CenterCrop(img_size)
  -- normalize
  local meanstd = {}
  meanstd.mean = {108.64628601/255, 75.86886597/255, 54.34005737/255}
  meanstd.std = {70.53946096/255, 51.71475228/255, 43.03428563/255}
  transforms[4] = T.ColorNormalize(meanstd)

  local totalTransform = T.Compose(transforms)
  return totalTransform
end

function loadImg(file)
	local img = gm.Image()
	local filestr = file:string()
  local ok = pcall(img.fromString, img, filestr)
  local err = nil
  filestr = nil
  if ok then
    img = img:toTensor("float", "RGB", "DHW")
	else
    err = "Failed to convert image file"
	  img = nil
	end
	return img,err
end

local transformer = generateTransformer()

function FeedForward(img)
	local response = {}
  local err = nil

	response["message"] = "OK"

	pred_img = torch.FloatTensor(num_transforms,3,img_size,img_size)
	for i=1,num_transforms do
	  pred_img[i] = transformer(img)
	end

	local out = model:forward(pred_img)
	response["grade_result"] = {}
	response["grade_result"]["prediction"] = tostring(torch.mean(out)-1)
	response["grade_result"]["prediction_std"] = tostring(torch.std(out))

	return response, err
end
