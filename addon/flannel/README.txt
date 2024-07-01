KUBERNETES FLANNEL, 202405

https://github.com/flannel-io/flannel/
https://github.com/flannel-io/flannel/releases
https://github.com/flannel-io/flannel/tree/v0.24.2/Documentation
https://github.com/flannel-io/flannel/blob/v0.24.2/Documentation/kube-flannel.yml

wget "https://raw.githubusercontent.com/flannel-io/flannel/v0.24.2/Documentation/kube-flannel.yml" -O kube-flannel.yml

cp -a kube-flannel.yml kube-flannel.yml_v0.24.2_bk_raw
diff -u kube-flannel.yml_v0.24.2_bk_raw kube-flannel.yml

sed -i "s|image: docker.io/|image: m.daocloud.io/docker.io/|g" kube-flannel.yml
diff -u kube-flannel.yml_v0.24.2_bk_raw kube-flannel.yml
--------------------------------------------------------
-        image: docker.io/flannel/flannel:v0.24.2
+        image: m.daocloud.io/docker.io/flannel/flannel:v0.24.2

-        image: docker.io/flannel/flannel-cni-plugin:v1.4.0-flannel1
+        image: m.daocloud.io/docker.io/flannel/flannel-cni-plugin:v1.4.0-flannel1

-        image: docker.io/flannel/flannel:v0.24.2
+        image: m.daocloud.io/docker.io/flannel/flannel:v0.24.2
--------------------------------------------------------

kubectl apply -f kube-flannel.yml
kubectl delete -f kube-flannel.yml
