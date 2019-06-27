docker build --tag=cert-generator .
docker run --rm -it -v ${PWD}\certificates:/certificates cert-generator
