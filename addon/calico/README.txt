KUBERNETES CALICO, 202405

https://github.com/projectcalico/calico
https://github.com/projectcalico/calico/releases
https://github.com/projectcalico/calico/blob/v3.27.0/manifests/calico.yaml

wget "https://raw.githubusercontent.com/projectcalico/calico/v3.27.0/manifests/calico.yaml" -c calico.yaml

cp -a calico.yaml calico.yaml_v3.27.0_bk_raw
diff -u calico.yaml_v3.27.0_bk_raw calico.yaml

diff -u calico.yaml_v3.27.0_bk_raw calico.yaml
----------------------------------------------
             # - name: CALICO_IPV4POOL_CIDR
             #   value: "192.168.0.0/16"
+            - name: CALICO_IPV4POOL_CIDR
+              value: "10.244.0.0/16"
----------------------------------------------

sed -i "s|image: docker.io/|image: m.daocloud.io/docker.io/|g" calico.yaml
diff -u calico.yaml_v3.27.0_bk_raw calico.yaml
----------------------------------------------
-          image: docker.io/calico/cni:v3.27.0
+          image: m.daocloud.io/docker.io/calico/cni:v3.27.0

-          image: docker.io/calico/kube-controllers:v3.27.0
+          image: m.daocloud.io/docker.io/calico/kube-controllers:v3.27.0
----------------------------------------------

kubectl apply -f calico.yaml
kubectl delete -f calico.yaml
