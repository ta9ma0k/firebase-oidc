# Github ActionsからOIDCを利用してFirebseProjectsをデプロイする設定

## 1.Terraformを実行する

### 変数

- project_id: GCPのプロジェクトID
- github_repository: リポジトリ名(accountName/repositoryName)

## 2.Workflowを更新する

`.github/workflows/deploy.yml`を参考にWorkflowを定義する

TerraformのOutputsのサービスアカウントとプロバイダーの情報を利用する

