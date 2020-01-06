# Install R Kernel for Jupyter
install.packages(c('IRdisplay', 'pbdZMQ'))
devtools::install_github('IRkernel/IRkernel', ref = '1.0.0', upgrade_dependencies = FALSE);

# kernel name = ir
IRkernel::installspec()
