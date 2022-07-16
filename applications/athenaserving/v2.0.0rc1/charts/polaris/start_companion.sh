docker run -d --network host \
--name companion \
--restart=always \
--privileged=true \
-v /etc/localtime:/etc/localtime \
-v /data1/log/companion/logs:/log/server \
hub.iflytek.com/aiaas/companion:2.0.3 sh watchdog.sh -h0.0.0.0  -p6868 -z10.251.86.152:2181  -whttp://companion.xfyun.cn
