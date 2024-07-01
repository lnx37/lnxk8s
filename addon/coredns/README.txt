KUBERNETES COREDNS, 202405

https://github.com/coredns/coredns
https://github.com/coredns/coredns/releases

https://github.com/coredns/deployment
https://github.com/coredns/deployment/tree/master/kubernetes
https://github.com/coredns/deployment/blob/master/kubernetes/CoreDNS-k8s_version.md
https://github.com/coredns/deployment/blob/master/kubernetes/coredns.yaml.sed
https://github.com/coredns/deployment/blob/master/kubernetes/deploy.sh

https://github.com/kubernetes/kubernetes/tree/v1.28.10/cluster/addons/dns/coredns
https://github.com/kubernetes/kubernetes/blob/v1.28.10/cluster/addons/dns/coredns/coredns.yaml.base
https://github.com/kubernetes/kubernetes/blob/v1.28.10/cluster/addons/dns/coredns/coredns.yaml.sed
https://github.com/kubernetes/kubernetes/blob/v1.28.10/cluster/addons/dns/coredns/transforms2sed.sed

wget "https://raw.githubusercontent.com/kubernetes/kubernetes/v1.28.10/cluster/addons/dns/coredns/coredns.yaml.sed" -O coredns.yaml.sed
wget "https://raw.githubusercontent.com/kubernetes/kubernetes/v1.28.10/cluster/addons/dns/coredns/coredns.yaml.base" -O coredns.yaml.base

cp -a coredns.yaml.sed coredns.yaml.sed_v1.10.1_bk_raw
cp -a coredns.yaml.base coredns.yaml.base_v1.10.1_bk_raw
diff -u coredns.yaml.sed_v1.10.1_bk_raw coredns.yaml.sed
diff -u coredns.yaml.base_v1.10.1_bk_raw coredns.yaml.base

cat coredns.yaml.base |grep "__"
--------------------------------
# __MACHINE_GENERATED_WARNING__
        kubernetes __DNS__DOMAIN__ in-addr.arpa ip6.arpa {
            memory: __DNS__MEMORY__LIMIT__
  clusterIP: __DNS__SERVER__
--------------------------------

sed -i "s/__DNS__DOMAIN__/cluster.local/g" coredns.yaml.base
sed -i "s/__DNS__MEMORY__LIMIT__/170Mi/g" coredns.yaml.base
sed -i "s/__DNS__SERVER__/10.96.0.10/g" coredns.yaml.base
sed -i "s|registry.k8s.io/coredns/coredns:v1.10.1|registry.aliyuncs.com/google_containers/coredns:v1.10.1|g" coredns.yaml.base
diff -u coredns.yaml.base_v1.10.1_bk_raw coredns.yaml.base
----------------------------------------------------------
-        kubernetes __DNS__DOMAIN__ in-addr.arpa ip6.arpa {
+        kubernetes cluster.local in-addr.arpa ip6.arpa {

-        image: registry.k8s.io/coredns/coredns:v1.10.1
+        image: registry.aliyuncs.com/google_containers/coredns:v1.10.1

-            memory: __DNS__MEMORY__LIMIT__
+            memory: 170Mi

-  clusterIP: __DNS__SERVER__
+  clusterIP: 10.96.0.10
----------------------------------------------------------

kubectl apply -f coredns.yaml.base
kubectl delete -f coredns.yaml.base

kubectl run -it --rm --image=busybox -- sh
nslookup kubernetes
nslookup kubernetes.default.svc.cluster.local
