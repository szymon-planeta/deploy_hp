#!/usr/bin/env bash

DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

INFLUX="$DIR/heapster/influxdb"
RBAC="$DIR/heapster/rbac"
SM="$DIR/scalingmonitor"

start() {
	heapster
	scalingmonitor
}

heapster() {
  if kubectl apply -f "$INFLUX" && kubectl create -f "$RBAC"; then
    echo "started heapster with influxdb backend"
  else
    echo "failed to start heapster with influxdb backend"
  fi
}

scalingmonitor() {
  if kubectl apply -f "$SM"; then
    echo "started scalingmonitor" 
  else
    echo "failed to start scalingmonitor"
  fi
}

stop() {
  echo -n "stopping..."
  kubectl delete -f "$INFLUX"
  kubectl delete -f "$RBAC"
  kubectl delete -f "$SM"
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
