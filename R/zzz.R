.onAttach <- function(libname, pkgname) {

  pkg.info <- drop(
    read.dcf(
      file = system.file("DESCRIPTION", package = pkgname),
      fields = c("Title", "Version")
    )
  )

  packageStartupMessage(
    paste0("dimControl: ", pkg.info["Title"], ",\n"),
    paste0("  version ", pkg.info["Version"], ".\n"),
    "  Developed by the MODES-CEMI group.\n",
    "  Type `help(package = \"dimControl\")` for an overview\n",
    "  or visit https://modes-cemi.github.io/dimControl/."
  )
}
