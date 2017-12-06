#!/usr/bin/env bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )/heapster"

INFLUX="$DIR/influxdb"
RBAC="$DIR/rbac"

start() {
  if kubectl apply -f "$INFLUX" && kubectl create -f "$RBAC"; then
    echo "started"
  else
    echo "failed to start"
  fi
}

stop() {
  echo -n "stopping..."
  kubectl delete -f "$INFLUX"
  kubectl delete -f "$RBAC"
  #kubectl --namespace kube-system delete svc,deployment,rc,rs -l task=monitoring &> /dev/null
  ## wait for the pods to disappear.
  #while kubectl --namespace kube-system get pods -l "task=monitoring" -o go-template --template '{{range .items}}{{.metadata.name}}{{"\n"}}{{end}}' | grep -c . &> /dev/null; do
  #  echo -n "."
  #  sleep 2
  #done
  echo
  echo "stopped"
}

case "$1" in
  start)
    start
    ;;
  stop)
    stop
    ;;
  restart)
    stop
    start
    ;;
  *)
    echo "Usage: $0 {start|stop|restart}"
    ;;
esac

exit 0
