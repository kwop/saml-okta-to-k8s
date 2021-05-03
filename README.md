# STARTER KIT

## TEST LOCALLY

Prerequisite

- bash
- make
- docker
- docker-compose
- Create a SAML2 application with OKTA.


Spin up the project

Update the .env file and replace the URL_SAML_METADATA with your app metadata url.

Next :

```
make start
```

Next :

Go to http://localhost:5000/

If you want to modify the project code : 

go to folder okta-pysaml2-front, flask will auto reload on code change.

## PUBLISH ON KUBERNETES

Prerequisites

- bash
- make
- nginx-ingress-controller > v0.9.0 
- kubernetes
- helm 3

Install helm charts

```
make install-firewalled-test
make install-okta-test
```

(optionnal)
Add hosts in /etc/hosts
```
<CLUSTER IP> okta-test.xip.io
<CLUSTER IP> firewalled.xip.io
```

Go to http://firewalled.xip.io

## Troubleshooting

Ingress controller error log (rke cluster)

( Adjust the namespace for your cluster spec )

```
kubectl get pod -n ingress-nginx
kubectl logs pod/<POD NAME> -n ingress-nginx
```

saml sp url troobleshoot

Go to http://okta-test.xip.io

DNS ingress fix 

See ingress annotation ( and change resolver ) : 

    nginx.ingress.kubernetes.io/auth-snippet: |
      resolver 127.0.0.53 valid=15s;

Play with the k8s/k3s node hosts...
