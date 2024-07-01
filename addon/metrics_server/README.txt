KUBERNETES METRICS SERVER, 202405

https://github.com/kubernetes-sigs/metrics-server
https://github.com/kubernetes-sigs/metrics-server/releases
https://github.com/kubernetes-sigs/metrics-server/releases/download/v0.7.0/components.yaml

https://github.com/kubernetes-sigs/metrics-server?tab=readme-ov-file#requirements
---------------------------------------------------------------------------------
Network should support following communication:
    Control plane to Metrics Server. Control plane node needs to reach Metrics Server's pod IP and port 10250 (or node IP and custom port if hostNetwork is enabled). Read more about control plane to node communication.
---------------------------------------------------------------------------------

wget "https://github.com/kubernetes-sigs/metrics-server/releases/download/v0.7.0/components.yaml" -O components.yaml

cp -a components.yaml components.yaml_v0.7.0_bk_raw
diff -u components.yaml_v0.7.0_bk_raw components.yaml

sed -i "s|image: registry.k8s.io|image: m.daocloud.io/registry.k8s.io|g" components.yaml
sed -i "/        - --metric-resolution=15s/a\        - --kubelet-insecure-tls" components.yaml
diff -u components.yaml_v0.7.0_bk_raw components.yaml
-----------------------------------------------------
         - --metric-resolution=15s
+        - --kubelet-insecure-tls

-        image: registry.k8s.io/metrics-server/metrics-server:v0.7.0
+        image: m.daocloud.io/registry.k8s.io/metrics-server/metrics-server:v0.7.0
-----------------------------------------------------

kubectl apply -f components.yaml
kubectl delete -f components.yaml

kubectl get svc -n kube-system
kubectl get pod -n kube-system

kubectl top node
kubectl top pod -A
