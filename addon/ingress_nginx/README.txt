KUBERNETES INGRESS NGINX, 202405

https://github.com/kubernetes/ingress-nginx
https://github.com/kubernetes/ingress-nginx/releases
https://github.com/kubernetes/ingress-nginx/tree/controller-v1.8.2
https://github.com/kubernetes/ingress-nginx/blob/controller-v1.8.2/deploy/static/provider/cloud/deploy.yaml

# kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.8.2/deploy/static/provider/cloud/deploy.yaml
wget "https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.8.2/deploy/static/provider/cloud/deploy.yaml" -O deploy.yaml

cp -a deploy.yaml deploy.yaml_v1.8.2_bk_raw
diff -u deploy.yaml_v1.8.2_bk_raw deploy.yaml

# sed -i "s|image: registry.k8s.io/|image: m.daoloud.io/registry.k8s.io/|g" deploy.yaml
sed -i "s|registry.k8s.io/ingress-nginx/controller|registry.cn-hangzhou.aliyuncs.com/google_containers/nginx-ingress-controller|g" deploy.yaml
sed -i "s|registry.k8s.io/ingress-nginx/kube-webhook-certgen|registry.cn-hangzhou.aliyuncs.com/google_containers/kube-webhook-certgen|g" deploy.yaml
sed -i '419i\      hostNetwork: true' deploy.yaml
diff -u deploy.yaml_v1.8.2_bk_raw deploy.yaml

kubectl apply -f deploy.yaml
kubectl delete -f deploy.yaml
kubectl delete namespace ingress-nginx

kubectl get pods --namespace=ingress-nginx
kubectl get services -A |grep "ingress"
kubectl get ingress

kubectl get ValidatingWebhookConfiguration
kubectl delete -A ValidatingWebhookConfiguration ingress-nginx-admission
