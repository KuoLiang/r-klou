# Define a vector of package names to be installed
packages_to_install <- c("RMySQL", "reshape2")
# Create a function to check for and install packages
install_if_missing <- function(pkg) {
  if (!requireNamespace(pkg, quietly = TRUE)) {
    install.packages(pkg)
  }
}
# Use lapply to apply the function to each package in the vector
lapply(packages_to_install, install_if_missing)

# Load the installed packages
lapply(packages_to_install, library, character.only = TRUE)
################
query_cast = function(query_result){
  query_df=fetch(query_result, n = -1) 
  mycast=dcast(query_df,
               firstname~Month,
               fun.aggregate = sum,
               value.var = "num",
               fill = NA_real_)
}
mysqlconnection = dbConnect(MySQL(), user = 'student', password = 'q[eTIK7PJO[r5pzG', 
                            dbname = 'northwind' ,host = '10.8.0.1')
dbListTables(mysqlconnection)