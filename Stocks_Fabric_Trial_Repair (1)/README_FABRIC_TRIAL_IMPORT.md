# Stocks project — Fabric Trial import package (v2)

This archive places Fabric item folders directly at the archive root. Every item folder's `.platform` file is included.

## Recommended import

1. Extract the ZIP locally.
2. Commit the item folders to a dedicated GitHub recovery branch/repository using Git; this preserves `.platform` dotfiles.
3. If using a new repository, put the item folders directly in the repository root and leave Fabric's **Git folder** setting blank. If using your existing repository where the top level is `Workspace Items/`, copy these item folders into that directory and set Fabric's Git folder to `Workspace Items`.
4. Connect an EMPTY Fabric workspace and choose **Connect and sync / Update from Git**.
5. Review the import result. Unsupported item types or invalid dependencies can still require separate repair.

## Windows / GitHub note

`.platform` starts with a dot and may be overlooked by file pickers. Do not omit it. From a local Git clone, copy the extracted item folders, then run `git add -A`; verify that `.platform` files appear in `git status` before committing.

## Data and dependencies

This is source metadata, not a full data backup. It does not include lakehouse table/file contents, Eventhouse streaming data, credentials, or external SQL database contents. After import, rebind notebooks to the new lakehouse/environment as needed, configure connections, and rebind KQL querysets to your own Eventhouse.

The KQL database script in the previous repair avoids `ingestion_time()` inside the transactional update-policy query by deriving the field from the stock payload timestamp. Verify that the actual incoming payload contains `StockInfo.main.timestamp` before running ingestion.
