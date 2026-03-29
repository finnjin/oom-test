FROM mcr.microsoft.com/dotnet/sdk:10.0
RUN dotnet tool install --global dotnet-dump && \
    dotnet tool install --global dotnet-counters
ENV PATH="$PATH:/root/.dotnet/tools"
ARG PROJECT_NAME
WORKDIR /app
RUN printf "#!/bin/bash\nPID=\$(pgrep -fo ${PROJECT_NAME})\nif [ -z \"\$PID\" ]; then echo \"No ${PROJECT_NAME} process found\"; exit 1; fi\necho \$PID\n" > /usr/local/bin/dotnet-pid && chmod +x /usr/local/bin/dotnet-pid && \
    printf '#!/bin/bash\nPID=$(dotnet-pid) || exit 1\nFILE="/tmp/dump_$(date +%%s).dmp"\ndotnet-dump collect -p $PID -o $FILE --type Full && dotnet-dump analyze $FILE\n' > /usr/local/bin/dump && chmod +x /usr/local/bin/dump && \
    printf '#!/bin/bash\nPID=$(dotnet-pid) || exit 1\ndotnet-counters monitor -p $PID --counters System.Runtime\n' > /usr/local/bin/counters && chmod +x /usr/local/bin/counters

COPY . .
RUN dotnet publish -c Release -o /out
ENTRYPOINT ["dotnet", "/out/OomTest.dll"]
