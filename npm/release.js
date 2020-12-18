const fs = require('fs')
const path = require('path')

const changelog = fs.readFileSync(path.join(__dirname, '..', 'CHANGELOG.adoc'))
const args = process.argv.slice(2)
const releaseVersion = args[0]

if (!releaseVersion) {
  console.log('Release version is undefined, please specify a version `npm run release 1.0.0`')
  process.exit(9)
}

const rx = new RegExp(`== ${releaseVersion}.*\\n(?<content>[\\s\\S]+?)\\n(?=== )`)
const changelogVersion = rx.exec(changelog)
if (changelogVersion && changelogVersion.groups && changelogVersion.groups.content) {
  fs.writeFileSync(path.join(__dirname, '..', 'dist', 'changelog.md'), changelogVersion.groups.content, 'utf8')
}
