export OPENBLAS_NUM_THREADS=1
export GOTO_NUM_THREADS=1
export OMP_NUM_THREADS=1
/usr/local/openresty/nginx/sbin/nginx -p "$(pwd)" -c "nginx.conf"
