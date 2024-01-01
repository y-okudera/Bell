# apollo

Codegen CLIの実行ファイルへのシンボリックリンクを作成

```
swift package --allow-writing-to-package-directory apollo-cli-install
```

apollo-codegen-config.jsonを生成

```
./apollo-ios-cli init --schema-namespace GitHub --module-type swiftPackageManager
```

Swiftファイルを生成

```
./apollo-ios-cli generate
```

# .env

.envファイルを読み込み、Swiftファイルを生成する

```
chmod +x load_env.sh
sh load_env.sh
```
