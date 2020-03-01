#!/bin/bash
kubectl delete -n default deployment vault
kubectl delete -n default statefulset consul
kubectl delete -n default configmap vault
kubectl delete -n default configmap consul
kubectl delete -n default secret vault
kubectl delete -n default secret consul
kubectl delete -n default service consul
kubectl delete -n default service vault