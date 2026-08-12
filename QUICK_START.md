# ⚡ QUICK START GUIDE

## 🎯 3 LANGKAH MUDAH:

---

### **STEP 1: Create GitHub Repository**

1. Buka: https://github.com/new
2. Repository name: `roblox-optimizm`
3. Visibility: ✅ **Public**
4. ❌ **JANGAN** add README/gitignore/license
5. Click **"Create repository"**

---

### **STEP 2: Push ke GitHub**

**Option A: Pakai Batch File (MUDAH)** ✅
```
Double-click: push_to_github.bat
Enter your GitHub username
Done!
```

**Option B: Manual (PowerShell)**
```powershell
cd "c:\Project Suka-Suka\VSPHONE\roblox-optimizm"
git branch -M main
git remote add origin https://github.com/YOUR_USERNAME/roblox-optimizm.git
git push -u origin main
```

---

### **STEP 3: Get LoadString**

Setelah push success, **LoadString URL** Anda:

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/YOUR_USERNAME/roblox-optimizm/main/sc_real.lua"))()
```

**Ganti `YOUR_USERNAME` dengan username GitHub Anda!**

---

## 📋 FILES IN THIS FOLDER:

| File | Purpose |
|------|---------|
| `sc_real.lua` | 🎮 **Main script** (optimization + auto-sell) |
| `README.md` | 📖 Full documentation |
| `SETUP_GITHUB.md` | 🔧 Detailed setup guide |
| `LOADSTRING.txt` | 📦 LoadString template |
| `push_to_github.bat` | ⚡ Quick push script |
| `QUICK_START.md` | 📝 This file |
| `.gitignore` | 🚫 Git ignore rules |

---

## ✅ VERIFY SUCCESS:

After push, check:

1. **GitHub page:** https://github.com/YOUR_USERNAME/roblox-optimizm
   - Should show: `sc_real.lua`, `README.md`, `.gitignore`

2. **Raw file:** https://raw.githubusercontent.com/YOUR_USERNAME/roblox-optimizm/main/sc_real.lua
   - Should show Lua code

3. **LoadString test:**
   ```lua
   loadstring(game:HttpGet("https://raw.githubusercontent.com/YOUR_USERNAME/roblox-optimizm/main/sc_real.lua"))()
   ```
   - Should load black overlay UI in Roblox

---

## 🔄 UPDATE SCRIPT NANTI:

Kalau Anda edit `sc_real.lua`:

```powershell
cd "c:\Project Suka-Suka\VSPHONE\roblox-optimizm"
git add sc_real.lua
git commit -m "Update script"
git push
```

LoadString otomatis pakai versi terbaru (no need change URL).

---

## 💡 PRO TIPS:

### **Tip 1: Repo HARUS Public**
Private repo = loadstring tidak bisa access (kecuali pakai token)

### **Tip 2: Wait 1-2 minutes setelah push**
GitHub butuh waktu sync raw file

### **Tip 3: Test di browser dulu**
Buka raw URL di browser, pastikan show Lua code

### **Tip 4: Cache issue?**
Kalau update tidak muncul, add version query:
```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/USER/roblox-optimizm/main/sc_real.lua?v=2"))()
```

### **Tip 5: Backup local**
Keep copy di `roblox script` folder for safety

---

## 🆘 TROUBLESHOOTING:

### **"Permission denied"**
Setup Git credentials:
```powershell
git config --global user.name "Your Name"
git config --global user.email "your@email.com"
```

### **"Repository not found"**
Check username spelling, check repo name

### **"Failed to push"**
```powershell
git pull origin main --allow-unrelated-histories
git push
```

### **LoadString not working**
- Check repo is Public
- Check raw URL in browser
- Wait 2 minutes after push
- Check executor supports HttpGet

---

## 📞 NEED HELP?

1. Read `SETUP_GITHUB.md` for detailed steps
2. Read `README.md` for script documentation
3. Check troubleshooting section above
4. Open issue on GitHub repo

---

## 🎉 THAT'S IT!

Sekarang script Anda ada di GitHub dan bisa di-load dengan 1 line code!

Share dengan teman:
```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/YOUR_USERNAME/roblox-optimizm/main/sc_real.lua"))()
```

**Good luck! 🚀**
