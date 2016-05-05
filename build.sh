set -e

if [ ! -e nuget.exe ]; then
    wget https://dist.nuget.org/win-x86-commandline/latest/nuget.exe
fi

dotnet restore
cd src/RdKafka.Internal.librdkafka
dotnet run -p ../../tools/Copy.Librdkafka
dotnet pack

if [ "$VERSION" = "" ]
then
    VERSION=0.9.1-ci-$TRAVIS_BUILD_NUMBER
fi

echo "Version: $VERSION"

if [ ! "$NUGET_API_KEY" = "" ]
then
    mono nuget.exe push bin/Debug/RdKafka.Internal.librdkafka.$VERSION.nupkg -ApiKey $NUGET_API_KEY -Source https://api.nuget.org/v3/index.json
fi