# Install R Kernel for Jupyter
install.packages(c('IRdisplay', 'pbdZMQ'))
devtools::install_github('IRkernel/IRkernel', ref = '1.1')

# kernel name = ir
IRkernel::installspec()
