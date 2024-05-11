#!/bin/bash

output_dir="mock_resources"
rm -rf "$output_dir"
mkdir "$output_dir"

# fruits=("apple" "banana" "orange" "grape" "kiwi" "mango" "pear" "cherry" "pineapple" "watermelon"
#   "lemon" "strawberry" "blueberry" "raspberry" "blackberry" "peach" "plum" "apricot" "nectarine" "pomegranate"
#   "fig" "date" "kiwi" "passionfruit" "dragonfruit" "papaya" "guava" "lychee" "avocado" "coconut"
#   "melon" "lime" "tangerine" "grapefruit" "cantaloupe" "apricot" "persimmon" "cranberry" "currant" "gooseberry"
#   "kiwano" "starfruit" "elderberry" "boysenberry" "rhubarb" "tamarillo" "quince" "mulberry" "kiwifruit")
fruits=("apple" "banana" "orange" "grape" "kiwi" "mango" "pear" "cherry" "pineapple" "watermelon"
  "lemon" "strawberry" "blueberry" "raspberry" "blackberry" "peach" "plum" "apricot" "nectarine" "pomegranate")

envs=("dev" "test" "stable" "pre" "gray" "prod")

for fruit in "${fruits[@]}"; do
  for env in "${envs[@]}"; do
    cat <<EOF >"$output_dir/mock-$fruit-$env.yaml"
apiVersion: v1
kind: Namespace
metadata:
  name: mock-$fruit
  labels:
    app.kubernetes.io/name: mock-$fruit
    fruit: $fruit
EOF

    cat <<EOF >>"$output_dir/mock-$fruit-$env.yaml"
---
apiVersion: apps/v1
kind: Deployment
metadata:
  name: mock-deployment-$fruit-$env
  namespace: mock-$fruit
  labels:
    app.kubernetes.io/name: mock-$fruit
    app.kubernetes.io/environment: $env
    fruit: $fruit
spec:
  replicas: 3
  selector:
    matchLabels:
      app.kubernetes.io/name: mock-$fruit
      app.kubernetes.io/environment: $env
      fruit: $fruit
  template:
    metadata:
      labels:
        app.kubernetes.io/name: mock-$fruit
        app.kubernetes.io/environment: $env
        fruit: $fruit
    spec:
      containers:
      - name: mock-container
        image: nginx:latest
EOF

    cat <<EOF >>"$output_dir/mock-$fruit-$env.yaml"
---
apiVersion: v1
kind: ConfigMap
metadata:
  name: mock-configmap-$fruit-$env
  namespace: mock-$fruit
  labels:
    app.kubernetes.io/name: mock-$fruit
    app.kubernetes.io/environment: $env
    fruit: $fruit
data:
  key1: value1
  key2: value2
EOF

    cat <<EOF >>"$output_dir/mock-$fruit-$env.yaml"
---
apiVersion: v1
kind: Secret
metadata:
  name: mock-secret-$fruit-$env
  namespace: mock-$fruit
  labels:
    app.kubernetes.io/name: mock-$fruit
    app.kubernetes.io/environment: $env
    fruit: $fruit
type: Opaque
data:
  username: dXNlcm5hbWU=
  password: cGFzc3dvcmQ=
EOF

    cat <<EOF >>"$output_dir/mock-$fruit-$env.yaml"
---
apiVersion: v1
kind: Service
metadata:
  name: mock-service-$fruit-$env
  namespace: mock-$fruit
  labels:
    app.kubernetes.io/name: mock-$fruit
    app.kubernetes.io/environment: $env
    fruit: $fruit
spec:
  selector:
    app.kubernetes.io/name: mock-$fruit
    app.kubernetes.io/environment: $env
    fruit: $fruit
  ports:
    - protocol: TCP
      port: 80
      targetPort: 80
EOF

    cat <<EOF >>"$output_dir/mock-$fruit-$env.yaml"
---
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: mock-ingress-$fruit-$env
  namespace: mock-$fruit
  labels:
    app.kubernetes.io/name: mock-$fruit
    app.kubernetes.io/environment: $env
    fruit: $fruit
spec:
  rules:
  - host: $fruit-$env.example.com
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: mock-service-$fruit-$env
            port:
              number: 80
EOF
  done
done

echo "Mock resources generated in $output_dir"
