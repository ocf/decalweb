[![Build and Deploy Decal Web](https://github.com/ocf/hugo-decal-web/actions/workflows/build.yml/badge.svg)](https://github.com/ocf/hugo-decal-web/actions/workflows/build.yml)

## Local Development
`nix develop`

## Deploy
`nix build`

## Adding New Facilitators

Go edit data/staff.yml

## Archiving
To archive the current year's website for a new semester, run `nix build`, and copy the resulting `/result` folder into `/20xx-fall` or `/20xx-spring`, under `/static/archives/`. 

Then, update the `/content/archives.md` page with the new archive. 

## TODO
- Create asynchronous curriculum website for Decal! 
- ~~make a template for staff bios lol: https://gohugo.io/templates/introduction/~~
- update resources list for 2026
- ~~staff training labs~~
- weekly schedule as a calendar
- ~~table of contents~~
- update any labs that might be confusing
- clean up css
- clarify videos on decal site
- Better archiving system & fixing relative links in archived websites
