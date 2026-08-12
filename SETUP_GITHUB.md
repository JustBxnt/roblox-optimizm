# 📝 Setup GitHub Repository

## 🎯 STEP 1: Create Repository di GitHub

1. **Buka GitHub:** https://github.com
2. **Login** dengan akun Anda
3. **Click** tombol **"+"** (kanan atas) → **"New repository"**
4. **Isi form:**
   - **Repository name:** `roblox-optimizm`
   - **Description:** `Roblox optimization script with FPS limiter and auto-sell`
   - **Visibility:** 
     - ✅ **Public** (recommended - biar bisa pakai loadstring)
     - ⚪ Private (tidak bisa loadstring gratis)
   - **Initialize:**
     - ❌ **JANGAN** centang "Add a README file"
     - ❌ **JANGAN** centang "Add .gitignore"
     - ❌ **JANGAN** pilih "Choose a license"
5. **Click** tombol **"Create repository"**

---

## 🎯 STEP 2: Push ke GitHub

Setelah repo dibuat, GitHub akan kasih instruksi. **ABAIKAN** instruksi itu, pakai yang ini:

### **Copy command ini ke PowerShell:**

```powershell
cd "c:\Project Suka-Suka\VSPHONE\roblox-optimizm"

git branch -M main

git remote add origin https://github.com/YOUR_USERNAME/roblox-optimizm.git

git push -u origin main
```

⚠️ **GANTI `YOUR_USERNAME`** dengan username GitHub Anda!

**Contoh:**
Jika username Anda `JustBxnt`, maka:
```powershell
git remote add origin https://github.com/JustBxnt/roblox-optimizm.git
```

---

## 🎯 STEP 3: Verify Upload

1. **Refresh** halaman repo GitHub Anda
2. **Pastikan** ada 3 files:
   - ✅ `sc_real.lua`
   - ✅ `README.md`
   - ✅ `.gitignore`

---

## 🎯 STEP 4: Get LoadString URL

Setelah file terupload, **loadstring URL** Anda adalah:

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/YOUR_USERNAME/roblox-optimizm/main/sc_real.lua"))()
```

**Contoh lengkap:**
```lua
-- Jika username: JustBxnt
loadstring(game:HttpGet("https://raw.githubusercontent.com/JustBxnt/roblox-optimizm/main/sc_real.lua"))()
```

---

## 📋 COMMAND CHEAT SHEET

### **Check current directory:**
```powershell
cd "c:\Project Suka-Suka\VSPHONE\roblox-optimizm"
pwd
```

### **Check git status:**
```powershell
git status
```

### **Check remote URL:**
```powershell
git remote -v
```

### **Update script (setelah edit):**
```powershell
cd "c:\Project Suka-Suka\VSPHONE\roblox-optimizm"
git add sc_real.lua
git commit -m "Update: [describe your changes]"
git push
```

### **Update README:**
```powershell
cd "c:\Project Suka-Suka\VSPHONE\roblox-optimizm"
git add README.md
git commit -m "Update README"
git push
```

---

## 🔧 TROUBLESHOOTING

### **Problem: "Permission denied"**
**Solution:** Setup Git credentials
```powershell
git config --global user.name "Your Name"
git config --global user.email "your.email@example.com"
```

Then use Personal Access Token (PAT) instead of password.

### **Problem: "Repository not found"**
**Solution:** Double check username and repo name
```powershell
# Check current remote:
git remote -v

# Remove wrong remote:
git remote remove origin

# Add correct remote:
git remote add origin https://github.com/CORRECT_USERNAME/roblox-optimizm.git
```

### **Problem: "Failed to push"**
**Solution:** Pull first, then push
```powershell
git pull origin main --allow-unrelated-histories
git push -u origin main
```

---

## ✅ VERIFICATION CHECKLIST

After setup, verify:
- [ ] Repository created on GitHub
- [ ] Files visible on GitHub (`sc_real.lua`, `README.md`, `.gitignore`)
- [ ] Repository is **Public** (untuk loadstring)
- [ ] LoadString URL working:
  ```
  https://raw.githubusercontent.com/YOUR_USERNAME/roblox-optimizm/main/sc_real.lua
  ```
- [ ] Can access raw file in browser (should show Lua code)

---

## 🎉 DONE!

Setelah semua selesai, Anda bisa share loadstring:

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/YOUR_USERNAME/roblox-optimizm/main/sc_real.lua"))()
```

**Test di Roblox executor:**
1. Copy loadstring
2. Paste di executor
3. Execute
4. Script should load dengan black overlay UI

---

## 📝 NOTES

### **Raw URL Format:**
```
https://raw.githubusercontent.com/USERNAME/REPO_NAME/BRANCH/FILE_PATH
```

**Example:**
```
https://raw.githubusercontent.com/JustBxnt/roblox-optimizm/main/sc_real.lua
```

### **Branch Names:**
- New repos: `main` (default)
- Old repos: `master` (legacy)

Check your branch:
```powershell
git branch
```

Should show: `* main`

---

## 🔄 UPDATING SCRIPT

When you edit `sc_real.lua`:

1. **Edit** file locally
2. **Save** changes
3. **Run commands:**
```powershell
cd "c:\Project Suka-Suka\VSPHONE\roblox-optimizm"
git add sc_real.lua
git commit -m "Update: [what you changed]"
git push
```

4. **Wait** 1-2 minutes for GitHub to update
5. **Test** loadstring again (it auto-pulls latest version)

---

**Good luck! 🚀**
