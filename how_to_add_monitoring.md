kubectl create ns monitoring
helm install --name prometheus --namespace=monitoring stable/prometheus

POD_NAME=prometheus-server-86887bb56b-vkzj2
kubectl --namespace monitoring port-forward $POD_NAME 9090

helm install --name grafana --namespace=monitoring stable/grafana

kubectl get secret --namespace monitoring grafana -o jsonpath="{.data.admin-password}" | base64 --decode


POD_NAME=grafana-64c4d47c98-jtgv9
kubectl --namespace monitoring port-forward $POD_NAME 3000