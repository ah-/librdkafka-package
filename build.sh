set -e

BASEVERSION=0.9.2

if [ -z "$TRAVIS_TAG" ];
then
    if [ "$VERSION" = "" ]
    then
        VERSION="$BASEVERSION-ci-$TRAVIS_BUILD_NUMBER"
        VERSION_SUFFIX="--version-suffix ci-$TRAVIS_BUILD_NUMBER"
    fi
else
    VERSION="$BASEVERSION"
    VERSION_SUFFIX=""
fi

echo "Version: $VERSION"

dotnet restore
cd src/RdKafka.Internal.librdkafka
dotnet run -p ../../tools/Copy.Librdkafka
dotnet pack $VERSION_SUFFIX

if [ ! "$NUGET_API_KEY" = "" ]
then
    if [ ! -e nuget.exe ]; then
        wget https://dist.nuget.org/win-x86-commandline/latest/nuget.exe
    fi

    mono nuget.exe push bin/Debug/RdKafka.Internal.librdkafka.$VERSION.nupkg -ApiKey $NUGET_API_KEY -Source https://api.nuget.org/v3/index.json
fi
