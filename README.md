# diff-filter

Filter unified diff by filepath pattern

Based on https://stackoverflow.com/a/37339566/675333


Requirements:

- gawk

References:

- Unified diff format: https://en.wikipedia.org/wiki/Diff#Unified_format

## Example

source.patch:
```diff
diff --git a/orig/a.txt b/orig/a.txt
deleted file mode 100644
index f70f10e..0000000
--- a/orig/a.txt
+++ /dev/null
@@ -1 +0,0 @@
-A
diff --git a/orig/b.txt b/mod/b.txt
index 223b783..a19a027 100644
--- a/orig/b.txt
+++ b/mod/b.txt
@@ -1 +1 @@
-B1
+B2
diff --git a/mod/c.txt b/mod/c.txt
new file mode 100644
index 0000000..3cc58df
--- /dev/null
+++ b/mod/c.txt
@@ -0,0 +1 @@
+C
```

```bash
./diff-filter '(a|b)\.txt' < source.patch > target.patch
```

target.patch:
```diff
diff --git a/orig/a.txt b/orig/a.txt
deleted file mode 100644
index f70f10e..0000000
--- a/orig/a.txt
+++ /dev/null
@@ -1 +0,0 @@
-A
diff --git a/orig/b.txt b/mod/b.txt
index 223b783..a19a027 100644
--- a/orig/b.txt
+++ b/mod/b.txt
@@ -1 +1 @@
-B1
+B2
```
