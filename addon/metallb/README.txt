KUBERNETES METALLB, 202405

wget "https://raw.githubusercontent.com/metallb/metallb/v0.14.3/config/manifests/metallb-native.yaml" -O metallb-native.yaml

cp -a metallb-native.yaml metallb-native.yaml_v0.14.3_bk_raw
diff -u metallb-native.yaml_v0.14.3_bk_raw metallb-native.yaml

sed -i "s|image: quay.io|image: m.daocloud.io/quay.io|g" metallb-native.yaml
diff -u metallb-native.yaml_v0.14.3_bk_raw metallb-native.yaml
--------------------------------------------------------------
-        image: quay.io/metallb/controller:v0.14.3
+        image: m.daocloud.io/quay.io/metallb/controller:v0.14.3

-        image: quay.io/metallb/speaker:v0.14.3
+        image: m.daocloud.io/quay.io/metallb/speaker:v0.14.3
--------------------------------------------------------------

kubectl apply -f metallb-native.yaml
kubectl delete -f metallb-native.yaml

---

------------------------------
cat <<EOF >metallb_ip_pool.yml
apiVersion: metallb.io/v1beta1
kind: IPAddressPool
metadata:
  name: first-pool
  namespace: metallb-system
spec:
  addresses:
  - 172.22.25.100-172.22.25.110

---

apiVersion: metallb.io/v1beta1
kind: L2Advertisement
metadata:
  name: example
  namespace: metallb-system
spec:
  ipAddressPools:
  - first-pool
EOF
------------------------------

kubectl apply -f metallb_ip_pool.yml
kubectl delete -f metallb_ip_pool.yml

---

kubectl create deployment nginx --image=nginx
kubectl expose deployment nginx --port=80 --type=LoadBalancer
kubectl delete deployment.apps/nginx service/nginx
