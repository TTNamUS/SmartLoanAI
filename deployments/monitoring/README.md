How to install `kube-prometheus-stack`

On Windows:

Use the web tool to clone a subdirectory:
https://download-directory.github.io/

Paste the link:
```
https://github.com/prometheus-community/helm-charts/tree/main/charts/kube-prometheus-stack
```

After downloading and extracting the file, copy it into the monitoring directory and rename it to `kube-prometheus-stack`.

On Ubuntu/Debian or MacOS, install SVN:
```
sudo apt install subversion    # Ubuntu/Debian
# or
brew install svn               # macOS
```
Then use SVN to clone the subdirectory:
```
svn export https://github.com/prometheus-community/helm-charts/trunk/charts/kube-prometheus-stack
```

Note: You must add `/trunk/` in the URL because GitHub uses SVN layout in the backend for this feature.