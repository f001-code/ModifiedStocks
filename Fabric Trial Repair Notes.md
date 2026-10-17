# Stocks project — Fabric Trial repair package

## What was changed
- In `EH_Stocks.KQLDatabase/DatabaseSchema.kql`, the `Bronze_Parse_StockInfo()` function no longer uses `ingestion_time()` for `IngestionTime`. It now derives that column from `StockInfo.main.timestamp` (the source fetch timestamp). This addresses the reported failure: transactional update policies cannot use `ingestion_time()` in this query with streaming ingestion enabled.
- The saved `EH_Stocks_queryset.KQLQueryset/RealTimeQueryset.json` query text was updated in the same way so its sample setup script does not reintroduce the incompatible expression.
- The original author's Eventhouse endpoint was replaced with a clearly marked placeholder in the stock notebook and company-details pipeline. Replace it with your own Eventhouse query URI before running these items.
- The Spark environment's `yfinance` pin was updated to 0.2.55, matching the repository's setup guide.

## What was validated
- All `.platform`, `.json`, `.pbir`, and `.pbism` files in the source ZIP parsed as valid JSON.
- The `.platform` logical IDs in this ZIP are unique.
- This does not guarantee that every item type is supported by your tenant/trial capacity, or that every definition will import successfully. It also does not recreate source data, connections, credentials, or dependent resources.

## Important manual setup still required
1. Use a **new empty Fabric workspace** and connect it to the `Workspace Items` directory in a dedicated repair branch/repository.
2. After importing, open each notebook and remove the old/missing lakehouse attachment, then attach your newly created `LH_Stocks` lakehouse. The notebook files contain references to the original author's workspace and lakehouse.
3. Replace `https://REPLACE-WITH-YOUR-EVENTHOUSE-CLUSTER-URI` with the query URI shown for your own Eventhouse in:
   - `01 Get Stock Details.Notebook/notebook-content.py`
   - `Get Company Details.DataPipeline/pipeline-content.json`
   Then commit the changes and sync again, or edit the imported items directly in Fabric.
4. Reconfigure pipeline connections. The pipelines refer to a `StockMetaData` SQL database/stored procedures (`Core.GetGetMetadataObjects`, `Core.StartTransfer`, and others) that are not included as a database backup in this ZIP. The pipelines will not run until that dependency is created or the pipeline logic is changed.
5. Configure the `bronze_company` external table/shortcut dependency used by KQL function `Bronze_Changed_CompanyInfo()`. The external table is not provisioned by this ZIP alone.
6. Reconfigure credentials, schedules, and permissions. The Git package does not contain secrets or data.
7. Validate the Eventhouse policy in your own database. The source function now uses the event's fetch timestamp as `IngestionTime`; this is not the exact physical ingestion time. If you require actual ingestion time, use a different architecture (for example, disable streaming ingestion only after evaluating its latency/ingestion implications, or process records outside this transactional update policy).

## Recommended import order
1. Connect Git and import definitions.
2. Fix notebook lakehouse attachments and publish the Environment.
3. Create/configure the Eventhouse and KQL database; inspect and apply the schema.
4. Configure the missing SQL metadata database and external table/shortcuts.
5. Configure pipeline connections and test each notebook independently before running pipelines.
6. Connect the semantic model/report to the recreated data source and configure credentials/refresh.

## Note about "Fabric Trial"
The project README says a Fabric Trial is a supported capacity option, but a trial does not make unsupported item types, missing connections, or missing data automatically compatible. Some item operations/features can depend on tenant settings and the currently available Fabric features.
