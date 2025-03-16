import 'package:flutter/material.dart';
import 'package:translate/component_result_tile.dart';
import 'package:translator/translator.dart';



class MainPage extends StatefulWidget {
  const MainPage({super.key});

  @override
  MainPageState createState() => MainPageState();
}

class MainPageState extends State<MainPage> {
  // final jaWord = await translator.translate(enWord, from: 'en', to: 'ja');
  // ----------------------- 変数類1 -----------------------
  final translator = GoogleTranslator();
  final TextEditingController targetTextController = TextEditingController();
  String targetText = '';
  final Map<String, String> languageMap = {
    'ja': '日本語',
    'en': '英語',
    'zh-cn': '中国語',
    'ko': '韓国語',
    'de': 'ドイツ語',
    'fr': 'フランス語',
    'it': 'イタリア語',
    'es': 'スペイン語',
    'pt': 'ポルトガル語'
  };
  String originalLanguage = 'ja';
  List<String> selectedLanguagesList = [];
  List<String> keepSelectedLanguagesList = [];
  Map<String, String> translatedTextMap = {};
  bool isGenerating = false;

  final ScrollController scrollController = ScrollController();
  final ScrollController scrollController2 = ScrollController();
  @override
  void dispose() {
    scrollController.dispose();
    scrollController2.dispose();
    super.dispose();
  }
  // -----------------------------------------------------



  @override
  Widget build(BuildContext context) {
    // ----------------------- 変数類2 -----------------------
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    double appBarHeight = AppBar().preferredSize.height;
    double bodyHeight = screenHeight - appBarHeight;
    // -----------------------------------------------------


    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('複数言語に翻訳'),
        backgroundColor: Color(0xffF3FAFF)
      ),
      body: Center(
        child: SingleChildScrollView(
          controller: scrollController,
          child: Container(
            constraints: BoxConstraints(maxWidth: 700),
            padding: EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // =================================== 翻訳元の文章 ===================================
                // ------------------------ タイトル ------------------------
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 7),
                  child: Text('翻訳元', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                ),
                // ---------------------------------------------------------
                // ------------------------ 翻訳元言語 -----------------------
                DropdownButton<String>(
                  focusColor: Colors.white,
                  value: originalLanguage,
                  onChanged: (String? newKey) {
                    if (newKey != null) {
                      setState(() {
                        originalLanguage = newKey;
                      });
                    }
                    if (selectedLanguagesList.contains(originalLanguage)) {
                      selectedLanguagesList.remove(originalLanguage);
                    }
                  },
                  items: languageMap.entries.map<DropdownMenuItem<String>>((entry) {
                    return DropdownMenuItem<String>(
                      value: entry.key,
                      child: Text(entry.value),
                    );
                  }).toList(),
                ),
                // ---------------------------------------------------------
                // -------------------- テキストフィールド --------------------
                Container(
                  height: 280,
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: '翻訳したい文章を入力してください',
                      border: InputBorder.none
                    ),
                    maxLines: null,
                    controller: targetTextController,
                    onChanged: (value) {
                      setState(() {
                        targetText = value;
                      });
                    },
                  ),
                ),
                // ---------------------------------------------------------
                // ==================================================================================


                // ==================================== 翻訳言語 =====================================
                Center(
                  child: Container(
                    width: 550,
                    margin: const EdgeInsets.symmetric(vertical: 50),
                    child: Column(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10),
                            color: Color(0xfff5f5f5),
                          ),
                          height: 140,
                          child: GridView.count(
                            crossAxisCount: 3,
                            childAspectRatio: 4.5,
                            children: languageMap.entries.map<CheckboxListTile>((entry) {
                              bool isEnabled = entry.key != originalLanguage;
                              return CheckboxListTile(
                                title: Text(
                                  entry.value,
                                  style: TextStyle(
                                    color: (isEnabled) ? Colors.black : Color(0xffdddddd),
                                  ),
                                ),
                                value: selectedLanguagesList.contains(entry.key),
                                onChanged: (isEnabled)
                                  ? (bool? value) {
                                    setState(() {
                                      if (selectedLanguagesList.contains(entry.key)) {
                                        selectedLanguagesList.remove(entry.key);
                                      } else {
                                        selectedLanguagesList.add(entry.key);
                                      }
                                    });
                                  }
                                  : null,
                                enabled: isEnabled, // originalLanguageKey と同じ言語は無効
                              );
                            }).toList(),
                          ),
                        ),

                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  selectedLanguagesList = [];
                                });
                              },
                              child: Text('全て解除')
                            ),
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  selectedLanguagesList = languageMap.keys.toList();
                                  selectedLanguagesList.remove(originalLanguage);
                                });
                              },
                              child: Text('全て選択')
                            ),

                          ]
                        ),
                      ],
                    ),
                  ),
                ),
                // ==================================================================================


                // ==================================== 翻訳ボタン ====================================
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 70),
                    child: TextButton(
                      style: TextButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 25, horizontal: 55),
                        backgroundColor: Color.fromARGB(255, 133, 183, 205),
                        disabledBackgroundColor: Color.fromARGB(50, 133, 183, 205),
                      ),
                      onPressed: (targetText.isEmpty || selectedLanguagesList.isEmpty)
                        ? null
                        : () async {
                          setState(() {
                            keepSelectedLanguagesList = [...selectedLanguagesList];
                            isGenerating = true;
                          });
                          scrollController.jumpTo(scrollController.position.maxScrollExtent);
                          for (var language in keepSelectedLanguagesList) {
                            final Translation translatedText = await translator.translate(
                              targetTextController.text,
                              from: originalLanguage,
                              to: language
                            );
                            setState(() {
                              translatedTextMap[language] = translatedText.text;
                            });
                          }
                          setState(() {
                            isGenerating = false;
                          });
                        },
                      child: Text('翻訳', style: TextStyle(fontSize: 19, color: Colors.white)),
                    ),
                  ),
                ),
                // ==================================================================================


                // ==================================== 翻訳結果 =====================================
                // ------------------------ タイトル ------------------------
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 7),
                  child: Text('翻訳結果', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                ),
                // ---------------------------------------------------------
                // -------------------- 各言語への翻訳結果 --------------------
                (isGenerating)
                ? Center(
                  child: SizedBox(
                    width: 140,
                    height: 500,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(
                          width: 60,
                          height: 60,
                          child: CircularProgressIndicator(
                            strokeWidth: 3
                          ),
                        ),
                        SizedBox(height: 20),
                        Text('翻訳中...', style: TextStyle(fontSize: 15))
                      ],
                    )
                  ),
                )
                : ListView.builder(
                  shrinkWrap: true,
                  controller: scrollController2,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: translatedTextMap.length,
                  itemBuilder: (context, index) {
                    return ComponentResultTile(
                      language: languageMap[keepSelectedLanguagesList[index]] ?? 'エラー',
                      resultText: translatedTextMap[keepSelectedLanguagesList[index]] ?? 'エラー'
                    );
                  },
                )
                // ---------------------------------------------------------
                // ==================================================================================
              ],
            )
          ),
        ),
      ),
    );
  }
}