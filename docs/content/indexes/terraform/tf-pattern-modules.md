+++
date = '2024-12-19T14:06:37-08:00'
draft = false
title = 'Terraform Pattern Modules'
linkTitle = 'Pattern Modules'
weight = 2
+++

{{% notice style="info" %}}

This page contains various views of the module index (catalog) for **Terraform Pattern Modules**. To see these views, **click on the expandable sections** with the "➕" sign below.

- {{% icon icon="code-branch" %}} To see the **full, unfiltered, unformatted module index** on GitHub, click [here](https://github.com/Azure/{{% siteparam base %}}/blob/main/docs/static/module-indexes/TerraformPatternModules.csv).

- {{% icon icon="download" %}} To download the source CSV file, click [here]({{% siteparam base %}}/module-indexes/TerraformPatternModules.csv).

{{% /notice %}}

## Module catalog

{{% notice style="note" %}}

Modules listed below that aren't shown with the status of **`Module Available 🟢`**, are currently in development and are not yet available for use. For proposed modules, see the [Proposed modules]({{% siteparam base %}}/indexes/terraform/tf-pattern-modules/#proposed-modules---) section below.

{{% /notice %}}

The following table shows the number of all available, orphaned and proposed **Terraform Pattern Modules**.

{{% moduleStats language="Terraform" moduleType="Pattern" showLanguage=true showClassification=true %}}

<br>

### Module Publication History - 📅

{{% expand title="➕ Module Publication History - Module names, status and owners" expanded="false" %}}

{{% moduleHistory header=true csv="/static/module-indexes/TerraformPatternModules.csv" language="Terraform" moduleType="pattern" exclude="Proposed :new:" monthsToShow=9999 %}}

{{% /expand %}}

---

### Published modules - 🟢 & 👀

{{% expand title="➕ Published Modules - Module names, status and owners" expanded="true" %}}

{{% moduleNameStatusOwners header=true csv="/static/module-indexes/TerraformPatternModules.csv" language="Terraform" moduleType="pattern" exclude="Proposed :new:" %}}

{{% /expand %}}

---

### Proposed modules - 🆕

{{% expand title="➕ Proposed Modules - Module names, status and owners" expanded="false" %}}

{{% moduleNameStatusOwners header=true csv="/static/module-indexes/TerraformPatternModules.csv" language="Terraform" moduleType="pattern" exclude="Available :green_circle:,Orphaned :eyes:" %}}

{{% /expand %}}

---

### All modules - 📇

{{% expand title="➕ All Modules - Module names, status and owners" expanded="false" %}}

{{% moduleNameStatusOwners header=true csv="/static/module-indexes/TerraformPatternModules.csv" language="Terraform" moduleType="pattern" %}}

{{% /expand %}}

---

## For Module Owners & Contributors

{{% notice style="note" %}}

This section is mainly intended **for module owners and contributors** as it contains information important for module development, such as **telemetry ID prefix, and GitHub Teams for Owners & Contributors**.

{{% /notice %}}

### Module name, Telemetry ID prefix, GitHub Teams for Owners & Contributors

{{% expand title="➕ All Modules - Module name, Telemetry ID prefix, GitHub Teams for Owners & Contributors" expanded="false" %}}

{{% moduleNameTelemetryGHTeams header=true csv="/static/module-indexes/TerraformPatternModules.csv" language="Terraform" moduleType="pattern"%}}

{{% /expand %}}