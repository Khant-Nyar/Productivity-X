My Productivity tools make with bash script collection for me and here if you want
English letter below

# What is Productivity-X ?

Productivity-X ဆိုတာ
web devloper တွေ‌,linux user တွေ အတွက် မသုံး၀င်တဲ့ bash script file လေတွေပါ ကို automatic script လေတွေ ရေးထားတာ ပါ ။ မည်သူမဆို လွတ်လပ်စွာအသုံး ပြုနိုင်ပါတယ် controbute လုပ်ချင်သူတိုင် အတွက်လဲ ကြိုဆိုနေပါတယ်ခဗျာ

တစ်ခုချင်းစီရဲ့ အသုံးပြုပုံတွေ အောက်မှာ ဆက်ရေးပေထားပါ့မယ် ခဗျ ။

## pushvps

pushVps ဆိုတာ တစ်ခါတစ်လေ ကျွန်တော် တို့ production server ပေါ်ကို code တွေ update လုပ်တဲံ့အခါ မှာ သုံးဖို့ ပါ CI,CD အသုံးပြုနိုင်သူများတွက် မလိုအပ်ပါ

```
./pushVps.sh --dir=/path/to/dir --geturl=https://github.com/your_username/your_repo.git
```

--help or -h နဲ့အသုံးပြုနည်းကို ကြည်လို့ရပါတယ်

## rsyup

rsyup ဆိုတာ တစ်ခါတစ်လေ ကျွန်တော် တို့ vps server ပေါ်ကို file တွေ download & upload လုပ်တဲ့ အခါ မှာ scp-copy ဆိုပြီးသုံးကြပါတယ် ဒီဟာကတော့ rsync ကိုသုံးပြီး upload download လုပ်မှာ ပါ ပိုပြီးမြန်ဆန်လွယ်ကူစေမယ် လို့ မျှောလင့်ပါတယ် ။

```
./script.sh -U -h 203.23.128.176 -u root -d /path/to/dir -S /path/to/dir
```

--help or -h နဲ့အသုံးပြုနည်းကို ကြည်လို့ရပါတယ်

## gitx

gitx ဆိုတော့ git command တွေကို ပိုပြီးလွယ်ကူမြန်မြန်ဆန်ဆန် သုံးနိုင်ဖို့ ရည်ရွယ်ပါတယ် ။ devloper တွေ အနေနဲ့တစ်ခါတစ်လေ localcode တွေရေးပြီးသာကို ရုံ git repo ပေါ်တင်တဲ့ အခါ အောက်ကအတိုင် အများကြီးရေးရပါတယ်

```
echo "# learning-laravel" >> README.md
git init
git add README.md
git commit -m "first commit"
git branch -M main
git remote add origin https://github.com/TripleKay/learning-laravel.git
git push -u origin main
```

ဒီ script မှာတော့

```
script init https://github.com/TripleKay/learning-laravel.git
```

ဆိုပြီး run နိုင်ပါတယ် ဒီမှာတော့ option တွေ အများကြီးပါလို့ -h နဲ့ help option ထုတ် ကြည်ပြီးစမ်းသုံးနိုင်ပါတယ် ။

```
./script.sh -U -h 203.23.128.176 -u root -d /path/to/dir -S /path/to/dir
```

--help or -h နဲ့အသုံးပြုနည်းကို ကြည်လို့ရပါတယ်

## devx

Devloper တွေအတွက် linux စသုံးရင်အသုံးများတဲ့ sotware တွေ တစ်ခါတည် install လုပ်ပေတဲ့ script ပါ os အသစ်တင်ပြီးတာနဲ့ script run ပြီး အဆင်သင်အသုံးပြုနိုင်ပါတယ်

--help or -h နဲ့အသုံးပြုနည်းကို ကြည်လို့ရပါတယ်
