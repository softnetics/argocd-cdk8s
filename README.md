# Argocd cdk8s

# Pre-requisites

- [Basic knowledge of Kubernetes](https://kubernetes.io/docs/tutorials/kubernetes-basics/)
- [Basic knowledge of Helm](https://helm.sh/docs/intro/quickstart/)

# Setup ArgoCD

Assume that you're going to install [Argocd](https://argo-cd.readthedocs.io/en/stable/) with [Helm](https://helm.sh/). You may need to override the default values of the ArgoCD chart. For example,

```yaml
# values.yaml
global:
  image:
    repository: 'softnetics/argocd-cdk8s'
    tag: '1.0.0' # Recheck the latest tag
```

Then, add the ArgoCD ConfigManagementPlugin after the ArgoCD installation.

```yaml
# plugin.yaml
apiVersion: argoproj.io/v1alpha1
kind: ConfigManagementPlugin
metadata:
  name: argocd-cdk8s-plugin
spec:
  version: v1.0
  init:
    command: [sh]
    args: ['-c', 'cdk8s synth']
  generate:
    command: [sh]
    args: ['-c', 'cat dist/*']
  # The plugin will be executed if and only if there's `main.ts` file in the root of the source directory.
  discover:
    fileName: './main.ts'
```

Finally, apply the plugin to the ArgoCD.

```bash
kubectl apply -f plugin.yaml
```

# References

Thank you for the following resources:

- [ArgoCD Custom Tools](https://argo-cd.readthedocs.io/en/stable/operator-manual/custom_tools/)
- [ArgoCD Config Management Plugins](https://argo-cd.readthedocs.io/en/stable/operator-manual/config-management-plugins/)
- [Integrate cdk8s with ArgoCD](https://shipit.dev/posts/integrating-cdk8s-with-argocd.html)
