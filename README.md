# PowerShell Learning Repository

This repository contains sample PowerShell scripts and notes I’m using while learning PowerShell.  
The goal is to keep everything simple, practical, and easy to follow.

---

## 🧩 What Is PowerShell?

PowerShell is a **task automation and configuration** framework created by Microsoft.  
It includes:

- A powerful **command-line shell**
- A full **scripting language**
- A large set of built‑in **cmdlets** (commands)
- Deep integration with Windows, .NET, files, processes, registry, and more

PowerShell is designed to automate repetitive tasks, manage systems, and build tools for DevOps, cloud, and administration.

---

## 📜 What Is a PowerShell Script?

A PowerShell script is simply a **text file containing PowerShell commands**, saved with the `.ps1` extension.

Scripts allow you to:

- Automate tasks  
- Run multiple commands in sequence  
- Build reusable tools  
- Create functions, modules, and workflows  

Instead of typing commands one by one, a script executes them all at once.

---

## ⚙️ How PowerShell Scripts Work

When you run a script:

1. PowerShell reads the `.ps1` file  
2. It executes each command from top to bottom  
3. Variables, functions, loops, and logic control how the script behaves  
4. Output is shown in the console or written to files/logs  

PowerShell uses the **.NET runtime**, so it can access .NET classes, objects, and APIs directly.

---

## 💾 What Is a `.ps1` File?

A `.ps1` file is the standard file format for PowerShell scripts.

Example:

```
MyScript.ps1
Install-App.ps1
Backup-Database.ps1
```

It is just a text file, but PowerShell recognizes `.ps1` as executable script content.

---

## 🛠️ How to Install PowerShell

### Windows
PowerShell 5.x is built in.  
To install PowerShell 7+ (PowerShell Core):

- Download from: https://github.com/PowerShell/PowerShell  
- Or install via Winget:

```
winget install Microsoft.PowerShell
```

### macOS

```
brew install --cask powershell
```

### Linux (Ubuntu example)

```
sudo apt-get install powershell
```

Run PowerShell:

```
pwsh
```

---

## ▶️ How to Run a PowerShell Script

### 1. Open PowerShell
Search for **PowerShell** or **pwsh** (PowerShell 7).

### 2. Navigate to the script folder

```
cd C:\Path\To\Your\Script
```

### 3. Run the script

```
.\MyScript.ps1
```

If you get a security warning, you may need to change the execution policy:

```
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
```

---

## 🧪 Basic PowerShell Syntax

### Variables

```powershell
$name = "Kasra"
$age = 30
```

### Write output

```powershell
Write-Host "Hello World"
Write-Output "This goes to the pipeline"
```

### If / Else

```powershell
if ($age -gt 18) {
    Write-Host "Adult"
} else {
    Write-Host "Minor"
}
```

### Loops

```powershell
for ($i = 1; $i -le 5; $i++) {
    Write-Host "Number: $i"
}
```

### Functions

```powershell
function Say-Hello {
    param($name)
    Write-Host "Hello $name"
}

Say-Hello "Kasra"
```

### Importing Modules

```powershell
Import-Module Az
```

### Running Cmdlets

```powershell
Get-Process
Get-Service
Get-ChildItem
```

---

## 📦 What This Repository Contains

- Sample PowerShell scripts  
- Notes and examples  
- Experiments while learning  
- Useful automation snippets  

---
