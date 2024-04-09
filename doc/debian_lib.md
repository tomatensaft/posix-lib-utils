# debian lib


## general debian commands/tools
```
wget https://packages.microsoft.com/config/debian/12/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
sudo dpkg -i packages-microsoft-prod.deb
rm packages-microsoft-prod.deb
```

## install sdk
```
sudo apt-get update && \
  sudo apt-get install -y dotnet-sdk-8.0
```

## install asp net core
```
sudo apt-get update && \
  sudo apt-get install -y aspnetcore-runtime-8.0
```

## install .net runtime
```
sudo apt-get install -y dotnet-runtime-8.0
```