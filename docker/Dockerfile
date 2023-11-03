FROM rocker/tidyverse:4.3.0

ENV RENV_VERSION 0.16.0
ENV ARROW_WITH_SNAPPY "ON"
ENV ARROW_S3 "ON"
ENV QUARTO_VERSION 1.3.450

RUN apt-get update && apt-get install -y --no-install-recommends \
  python3-pip \
  && pip install -U radian

RUN R -e "install.packages('remotes', repos = c(CRAN = 'https://cloud.r-project.org'))"
RUN R -e "remotes::install_github('rstudio/renv@${RENV_VERSION}')"

ENV RENV_PATHS_LIBRARY renv/library
WORKDIR /project
COPY renv.lock renv.lock
RUN R -e "renv::restore()"

# RUN mkdir -p /renv/cache

# Installing Quarto
RUN TEMP_QUARTO="$(mktemp)" && \
  wget -O "$TEMP_QUARTO" https://github.com/quarto-dev/quarto-cli/releases/download/v$QUARTO_VERSION/quarto-${QUARTO_VERSION}-linux-amd64.deb && \
  sudo dpkg -i "$TEMP_QUARTO" && \
  rm -f "$TEMP_QUARTO"


# https://github.com/quarto-dev/quarto-cli/releases/download/v1.3.450/quarto-1.3.450-linux-arm64.deb