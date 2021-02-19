FROM jupyter/scipy-notebook

RUN python --version

RUN conda install --quiet --yes -c \
    conda-forge osmnx dask

RUN pip install -U rtree \
                   folium \
                   shapely \
                   fiona \
                   six \
                   pyproj \
                   numexpr==2.6.4 \
                   plotly \
                   tqdm \
                   mapboxgl \
                   cufflinks \
                   tables \
                   mixpanel

VOLUME /runbooks
WORKDIR /runbooks
