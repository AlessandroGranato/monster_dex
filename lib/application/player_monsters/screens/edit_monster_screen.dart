import 'dart:math';

import 'package:flutter/material.dart';
import 'package:monster_dex/providers/monster.dart';
import 'package:monster_dex/providers/monsters.dart';
import 'package:provider/provider.dart';

class EditMonsterScreen extends StatefulWidget {
  static String routeName = "/edit-monster";
  const EditMonsterScreen({Key? key}) : super(key: key);

  @override
  State<EditMonsterScreen> createState() => _EditMonsterScreenState();
}

class _EditMonsterScreenState extends State<EditMonsterScreen> {
  Monster editMonster = Monster.noArgs();
  var _formKey = GlobalKey<FormState>();
  var _nameFocusNode = FocusNode();
  var _strengthsFocusNode = FocusNode();
  var _weaknessesFocusNode = FocusNode();
  var _notesFocusNode = FocusNode();
  var _imageUrlFocusNode = FocusNode();
  var _imageUrlController = TextEditingController();
  var _isDefeatedFocusNode = FocusNode();
  var _bountyFocusNode = FocusNode();
  var isInit = true;

  @override
  void initState() {
    _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (isInit) {
      var arguments =
          ModalRoute.of(context)!.settings.arguments as Map<String, String>?;
      if (arguments != null) {
        var monsterId = arguments['monsterId'];
        if (monsterId != null) {
          editMonster = Provider.of<Monsters>(context).findById(monsterId)!;
          _imageUrlController.text = editMonster.imageUrl;
        }
      }
    }
    isInit = false;
    print('EditMonster at the beginning');
    print('id: ${editMonster.id}');
    print('name: ${editMonster.name}');
    print('bounty: ${editMonster.bounty}');
    print('imageUrl: ${editMonster.imageUrl}');
    print('isDefeated: ${editMonster.isDefeated}');
    print('notes: ${editMonster.notes}');
    print('strengths: ${editMonster.strengths}');
    print('weaknesses: ${editMonster.weaknesses}');
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _nameFocusNode.dispose();
    _strengthsFocusNode.dispose();
    _weaknessesFocusNode.dispose();
    _notesFocusNode.dispose();
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _imageUrlFocusNode.dispose();
    _imageUrlController.dispose();
    _isDefeatedFocusNode.dispose();
    _bountyFocusNode.dispose();
    super.dispose();
  }

  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      if (_imageUrlController == null || _imageUrlController.text.isEmpty) {
        return;
      }
      if (!_imageUrlController.text.startsWith('http') &&
          !_imageUrlController.text.startsWith('https')) {
        return;
      }
      if (!_imageUrlController.text.endsWith('.png') &&
          !_imageUrlController.text.endsWith('.jpg') &&
          !_imageUrlController.text.endsWith('.jpeg')) {
        return;
      }
      setState(() {});
    }
  }

  //TODO - GESTIRE isLoading nella nuova maniera

  Future<void> _saveForm(BuildContext context) async {
    var scaffoldMessenger = ScaffoldMessenger.of(context);
    var isFormValid = _formKey.currentState!.validate();
    if (!isFormValid) {
      return;
    }
    _formKey.currentState!.save();
    print('EditMonster before saving');
    print('id: ${editMonster.id}');
    print('name: ${editMonster.name}');
    print('bounty: ${editMonster.bounty}');
    print('imageUrl: ${editMonster.imageUrl}');
    print('isDefeated: ${editMonster.isDefeated}');
    print('notes: ${editMonster.notes}');
    print('strengths: ${editMonster.strengths}');
    print('weaknesses: ${editMonster.weaknesses}');

    var monstersData = Provider.of<Monsters>(context, listen: false);
    Monster? existingMonster = monstersData.findById(editMonster.id);
    try {
      if (existingMonster != null) {
        var indexWhere = monstersData.getMonsters
            .indexWhere((element) => element.id == editMonster.id);
        await monstersData.updateMonster(indexWhere, editMonster);
      } else {
        await monstersData.addMonster(editMonster);
      }
    } catch (err) {
      scaffoldMessenger.showSnackBar(SnackBar(
        content: Text(
          err.toString(),
          textAlign: TextAlign.center,
        ),
      ));

      await showDialog(
          context: context,
          builder: (ctx) => AlertDialog(
                title: Text('An error occurred'),
                content: Text(err.toString()),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.of(ctx).pop(),
                      child: Text('Ok'))
                ],
              ));
    }

    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Save Monster'),
        actions: [
          IconButton(
              onPressed: () => _saveForm(context), icon: Icon(Icons.save))
        ],
      ),
      body: Padding(
          padding: EdgeInsets.all(8),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
                child: Column(
              children: [
                TextFormField(
                  decoration: InputDecoration(labelText: 'Name'),
                  initialValue: editMonster.name,
                  textInputAction: TextInputAction.next,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please provide a value';
                    }
                    return null;
                  },
                  onFieldSubmitted: (_) =>
                      FocusScope.of(context).requestFocus(_bountyFocusNode),
                  onSaved: (value) {
                    editMonster = editMonster.copyWith(name: value);
                  },
                ),
                TextFormField(
                  decoration: InputDecoration(labelText: 'Bounty'),
                  initialValue: editMonster.bounty.toString(),
                  focusNode: _bountyFocusNode,
                  textInputAction: TextInputAction.next,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please provide a value';
                    }
                    if (double.tryParse(value) == null) {
                      return 'Please provide a valid bounty';
                    }
                    if (double.parse(value) < 0) {
                      return 'Please provide a bounty higher than 0';
                    }
                    return null;
                  },
                  onFieldSubmitted: (_) =>
                      FocusScope.of(context).requestFocus(_notesFocusNode),
                  onSaved: (value) {
                    editMonster =
                        editMonster.copyWith(bounty: double.parse(value!));
                  },
                ),
                //INSERT HERE IS_DEFEATED FORM
                //INSERT HERE STRENTGH FORM
                //INSERT HERE WEAKNESSES FORM
                TextFormField(
                  decoration: InputDecoration(labelText: 'Notes'),
                  initialValue: editMonster.notes,
                  focusNode: _notesFocusNode,
                  textInputAction: TextInputAction.newline,
                  keyboardType: TextInputType.multiline,
                  maxLines: 3,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please provide a value';
                    }
                    if (value.length < 10) {
                      return 'Notes must be longer than 10 characters';
                    }
                    return null;
                  },
                  onFieldSubmitted: (_) =>
                      FocusScope.of(context).requestFocus(_isDefeatedFocusNode),
                  onSaved: (value) {
                    editMonster = editMonster.copyWith(notes: value);
                  },
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Container(
                      height: 100,
                      width: 100,
                      margin: EdgeInsets.only(
                        top: 8,
                        right: 10,
                      ),
                      decoration: BoxDecoration(
                          border: Border.all(width: 1, color: Colors.grey)),
                      child: _imageUrlController.text.isEmpty
                          ? Text('Enter a URL')
                          : FittedBox(
                              child: Image.network(
                              _imageUrlController.text,
                              fit: BoxFit.cover,
                            )),
                    ),
                    Expanded(
                      child: TextFormField(
                        decoration: InputDecoration(labelText: 'image URL'),
                        textInputAction: TextInputAction.done,
                        keyboardType: TextInputType.url,
                        focusNode: _imageUrlFocusNode,
                        controller: _imageUrlController,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please provide a URL';
                          }
                          if (!value.startsWith('http') &&
                              !value.startsWith('https')) {
                            return 'Please provide a valid URL';
                          }
                          if (!value.endsWith('.png') &&
                              !value.endsWith('.jpg') &&
                              !value.endsWith('.jpeg')) {
                            return 'Please provide an image URL';
                          }
                          return null;
                        },
                        onFieldSubmitted: (_) {
                          setState(() {});
                          _saveForm(context);
                        },
                        onSaved: (value) {
                          editMonster = editMonster.copyWith(imageUrl: value);
                        },
                      ),
                    ),
                  ],
                )
              ],
            )),
          )),
    );
  }
}
