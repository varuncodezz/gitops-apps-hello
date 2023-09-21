# Build Status

[![Build Status](https://mtvlabcicda1-app.brainupgrade.in/buildStatus/icon?job=gitops-apps-hello%2Fmain)](https://mtvlabcicda1-app.brainupgrade.in/job/gitops-apps-hello/job/main/)

# RBAC
kubectl create role jenkins -n jenkins --verb=create,list,get,watch,delete --resource=pods,pods/log,pods/exec,deploy,svc
kubectl create rolebinding jenkins -n jenkins --role=jenkins --serviceaccount=jenkins/default
