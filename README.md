# Masseeksperimentet
Code for community data analysis and shiny app.

## Shiny app
Export static app using [shinylive](https://posit-dev.github.io/r-shinylive/):
```
shinylive::export(appdir = "app", destdir = "docs")
usethis::use_github_action(url="https://github.com/posit-dev/r-shinylive/blob/actions-v1/examples/deploy-app.yaml")
httpuv::runStaticServer("./docs", headers = c(`Access-Control-Allow-Origin` = "*"))
```

Serving it through RStudio on BioCloud through OOD might not work, but it will locally. GitHub actions will build the site automatically with every commit to serve it on pages, but ensure `docs/app.json` doesn't exceed 100MB before committing changes.