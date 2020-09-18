import 'package:flutter/material.dart';
import '../provider/product.dart';

// Stateful here because have to mange user input
class EditProductScreen extends StatefulWidget {
  static const routeName = '/edit-product';

  @override
  _EditProductScreenState createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  final _priceFocusNode = FocusNode();
  final _descriptionFocusNode = FocusNode();
  final _imageUrlController = TextEditingController();
  final _imageUrlFocusNode = FocusNode();

  // GlobalKey is used to interact with a widget from inside the code
  // This variable will be used to save/submit the form
  final _form = GlobalKey<FormState>();

  // This is the product that the user is trying to edit
  var _editedProduct = Product(id: null, title: '', price: 0, description: '', imageUrl: '');

  @override
  void initState() {
    // Tells Flutter to execute _updateImageUrl whenever focus changes
    _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  // Instead of always wanting the user to click on the done button for the image for the image to
  // appear, the user can now just get out of focus and the image will appear.
  void _updateImageUrl() {
    if (!_imageUrlFocusNode.hasFocus) {
      // This causes the screen to rebuild
      setState(() {});
    }
  }

  // Have to get rid of the focus nodes otherwise they'll just stay here and cause a memory leak.
  @override
  void dispose() {
    _imageUrlFocusNode.removeListener(_updateImageUrl);
    _priceFocusNode.dispose();
    _descriptionFocusNode.dispose();
    _imageUrlController.dispose();
    _imageUrlFocusNode.dispose();
    super.dispose();
  }

  void _saveForm() {
    // This will trigger all the validators
    // will return true if there's no error, else false if there's at least one error
    final isValid = _form.currentState.validate();

    // Prevents the follow code to not be run if isValid isn't true
    if (!isValid) return;

    // This is a method provided by the form widget that will save the form
    // This triggers a method on every TextFormField that will take all the value entered
    // into a global map.
    _form.currentState.save();

    print(_editedProduct.title);
    print(_editedProduct.description);
    print(_editedProduct.price);
    print(_editedProduct.imageUrl);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Product'),
        actions: [
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveForm,
          )
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: _form,
          child: ListView(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: 'Title'),
                // textInputAction = Controls what the bottom right will show in the soft keyboard
                textInputAction: TextInputAction.next,
                // This will be called whenever the textInputAction is pressed
                onFieldSubmitted: (value) {
                  FocusScope.of(context).requestFocus(_priceFocusNode);
                },
                // value is the text entered
                // The return string is the error response that you want to give to the user.
                // if return null is reached, that means that no problems occured
                validator: (value) {
                  if (value.isEmpty)
                    return 'Please enter a value';
                  else {
                    return null;
                  }
                },

                // Creating a new Product each time onSaved is called since all the variables of a product are final
                onSaved: (value) {
                  _editedProduct = Product(
                    title: value,
                    price: _editedProduct.price,
                    description: _editedProduct.description,
                    imageUrl: _editedProduct.imageUrl,
                    id: null,
                  );
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Price'),
                // textInputAction = Controls what the bottom right will show in the soft keyboard
                textInputAction: TextInputAction.next,
                // Makes it so that only numbers can be entered in the soft keyboard
                keyboardType: TextInputType.number,
                focusNode: _priceFocusNode,
                onFieldSubmitted: (value) {
                  FocusScope.of(context).requestFocus(_descriptionFocusNode);
                },
                // Creating a new Product each time onSaved is called since all the variables of a product are final
                onSaved: (value) {
                  _editedProduct = Product(
                    title: _editedProduct.title,
                    price: double.parse(value),
                    description: _editedProduct.description,
                    imageUrl: _editedProduct.imageUrl,
                    id: null,
                  );
                },
              ),
              TextFormField(
                decoration: InputDecoration(labelText: 'Description'),
                maxLines: 3,
                focusNode: _descriptionFocusNode,
                keyboardType: TextInputType.multiline,

                // Creating a new Product each time onSaved is called since all the variables of a product are final
                onSaved: (value) {
                  _editedProduct = Product(
                    title: _editedProduct.title,
                    price: _editedProduct.price,
                    description: value,
                    imageUrl: _editedProduct.imageUrl,
                    id: null,
                  );
                },
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    margin: EdgeInsets.only(
                      top: 8,
                      right: 10,
                    ),
                    decoration: BoxDecoration(
                      border: Border.all(width: 1, color: Colors.grey),
                    ),
                    child: _imageUrlController.text.isEmpty
                        ? Text('Enter a URL')
                        : FittedBox(
                            child: Image.network(_imageUrlController.text),
                            fit: BoxFit.cover,
                          ),
                  ),
                  Expanded(
                    child: TextFormField(
                      decoration: InputDecoration(labelText: 'Image Url'),
                      keyboardType: TextInputType.url,
                      textInputAction: TextInputAction.done,
                      // Have this controller because I want this information before the form is submitted.
                      // This controller is updated only when the done button is pressed.
                      // That's why textInputAction: is set to TextInputAction.done
                      controller: _imageUrlController,
                      focusNode: _imageUrlFocusNode,
                      // Creating a new Product each time onSaved is called since all the variables of a product are final
                      onSaved: (value) {
                        _editedProduct = Product(
                          title: _editedProduct.title,
                          price: _editedProduct.price,
                          description: _editedProduct.description,
                          imageUrl: value,
                          id: null,
                        );
                      },

                      onFieldSubmitted: (value) {
                        _saveForm();
                      },
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
