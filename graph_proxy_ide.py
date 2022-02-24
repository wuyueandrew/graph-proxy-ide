
from kubernetes import client, config

import yaml
import copy
import logging
import time

logger = logging.getLogger()

class k8s_launcher(object):

    def __init__(self) -> None:
        with open("/home/graphscope/gs/graph-ide.yaml") as f:
            self._dep = yaml.safe_load(f)
        with open("/home/graphscope/gs/graph-svc.yaml") as f:
            self._svc = yaml.safe_load(f)
        config.load_incluster_config()
        self._v1_api = client.CoreV1Api()
        self._app_api = client.AppsV1Api()

    def submit_ide_task(self,):
        logger.info("=====graph proxy ide submit task=====")
        cp_dep = copy.deepcopy(self._dep)

        resp_service = self._v1_api.create_namespaced_service(body=self._svc, namespace="graph-manager")

        resp_deployment = self._app_api.create_namespaced_deployment(body=cp_dep, namespace="graph-manager")



    def kill_task(self):
        logger.info("=====graph proxy ide kill task=====")
        self._app_api.delete_namespaced_deployment(name="graphscope-coordinator-ide", namespace="graph-manager")


if __name__ == "__main__":
    logger.info("=====graph proxy ide start=====")
    launcher = k8s_launcher()
    launcher.submit_ide_task()

    time.sleep(1800)

    launcher.kill_task()
