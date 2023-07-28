# RBAC
kubectl create role jenkins -n jenkins --verb=create,list,get,watch,delete --resource=pods,pods/log,pods/exec,deploy,svc
kubectl create rolebinding jenkins -n jenkins --role=jenkins --serviceaccount=jenkins/default