#!/bin/bash
kubectl delete -n consul statefulset consul
kubectl delete -n consul configmap consul
kubectl delete -n consul secret consul
kubectl delete -n consul service consul
