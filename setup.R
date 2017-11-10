# Install civis R client
options(unzip='internal');
devtools::install_github('civisanalytics/civis-r', ref = 'v1.1.0', upgrade_dependencies = FALSE);

# Install R Kernel for Jupyter
install.packages(c('IRdisplay', 'pbdZMQ'))
devtools::install_github('IRkernel/IRkernel', ref = '0.7.1', upgrade_dependencies = FALSE);

# kernel name = ir
IRkernel::installspec()
