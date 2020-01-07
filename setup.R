# Install R Kernel for Jupyter
install.packages(c('IRdisplay', 'pbdZMQ'))
devtools::install_github('IRkernel/IRkernel', ref = '1.0.2');

# kernel name = ir
IRkernel::installspec()
