import 'package:flutter/material.dart';
import '../provider/product.dart';
import '../provider/products_provider.dart';
import 'package:provider/provider.dart';

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

  var _isInit = true;
  var _isLoading = false;

  var _initValues = {
    'title': '',
    'description': '',
    'price': '',
    'imageUrl': '',
  };

  @override
  void initState() {
    // Tells Flutter to execute _updateImageUrl whenever focus changes
    _imageUrlFocusNode.addListener(_updateImageUrl);
    super.initState();
  }

  // runs before build is executed
  // the if is there to make sure that this method doesn't run constantly
  @override
  void didChangeDependencies() {
    // Check to see if the product is initialized already. Aka: Does the product need to be edited?
    if (_isInit) {
      // gets the productId passed from the user_product_item.dart widget
      final productId = ModalRoute.of(context).settings.arguments as String;

      // Checks to see if a product was passed or not.
      // if it was passed, then set the initial values.
      if (productId != null) {
        _editedProduct =
            Provider.of<ProductsProvider>(context, listen: false).findProductById(productId);
        _initValues = {
          'title': _editedProduct.title,
          'description': _editedProduct.description,
          'price': _editedProduct.price.toString(),
//          'imageUrl': _editedProduct.imageUrl,
          'imageUrl': '',
        };
        // Because I'm using a controller for the imageUrl, initializing the TextFormField works like this
        _imageUrlController.text = _editedProduct.imageUrl;
      }
    }

    _isInit = false;
    super.didChangeDependencies();
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
    setState(() {
      _isLoading = true;
    });

    // Check to see if we're editing a product or adding a product
    // if the product exists then update the product
    if (_editedProduct.id != null) {
      Provider.of<ProductsProvider>(context, listen: false)
          .updateProduct(_editedProduct.id, _editedProduct);
      setState(() {
        _isLoading = false;
      });
      Navigator.of(context).pop();
    }
    // else if the product doesn't exist, add the product
    else {
      //    Adds the new product. Listen is false because idc about changes to the list, I just want to perform an action
      Provider.of<ProductsProvider>(context, listen: false)
          .addProduct(_editedProduct)
          .catchError((error) {
        // return showDialog here because it's of data type future. This causes the .then to be called only when after clicking the FlatButton
        return showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('An error occured!'),
            content: Text('Something went wrong.'),
            actions: [
              FlatButton(
                child: Text('Okay'),
                onPressed: () {
                  print('Did this work???');
                  // This pop gets rid of the AlertDialog
                  Navigator.of(context).pop();

                  // This pop moves back to the user_products_screen
                  Navigator.of(context).pop();
                },
              )
            ],
          ),
        );
      })
          // The .then is for working with a loading indicator. Look at how .addProduct is coded
          .then((response) {
        setState(() {
          _isLoading = false;
        });
        Navigator.of(context).pop();
      });
    }
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
      // If the app is loading, show the circular progress indicator
      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: EdgeInsets.all(16.0),
              child: Form(
                key: _form,
                child: ListView(
                  children: [
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Title'),
                      // sets the initial value of the TextFormField. This is mostly used for editing products
                      initialValue: _initValues['title'],
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
                          id: _editedProduct.id,
                          isFavorite: _editedProduct.isFavorite,
                        );
                      },
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Price'),
                      initialValue: _initValues['price'],
                      // textInputAction = Controls what the bottom right will show in the soft keyboard
                      textInputAction: TextInputAction.next,
                      // Makes it so that only numbers can be entered in the soft keyboard
                      keyboardType: TextInputType.number,
                      focusNode: _priceFocusNode,
                      onFieldSubmitted: (value) {
                        FocusScope.of(context).requestFocus(_descriptionFocusNode);
                      },

                      // The value that is passed back is a string type.
                      validator: (value) {
                        if (value.isEmpty) return 'Please enter a price';

                        // Try to parse the value. If it isn't parsable, there's an error
                        if (double.tryParse(value) == null) return 'Please enter a valid number';

                        if (double.parse(value) <= 0)
                          return 'Please enter a number greater than zero.';

                        return null;
                      },

                      // Creating a new Product each time onSaved is called since all the variables of a product are final
                      onSaved: (value) {
                        _editedProduct = Product(
                          title: _editedProduct.title,
                          price: double.parse(value),
                          description: _editedProduct.description,
                          imageUrl: _editedProduct.imageUrl,
                          id: _editedProduct.id,
                          isFavorite: _editedProduct.isFavorite,
                        );
                      },
                    ),
                    TextFormField(
                      decoration: InputDecoration(labelText: 'Description'),
                      initialValue: _initValues['description'],
                      maxLines: 3,
                      focusNode: _descriptionFocusNode,
                      keyboardType: TextInputType.multiline,

                      validator: (value) {
                        if (value.isEmpty) return 'Please enter a description';

                        if (value.length < 10)
                          return 'Description should be at least 10 characters long';

                        return null;
                      },

                      // Creating a new Product each time onSaved is called since all the variables of a product are final
                      onSaved: (value) {
                        _editedProduct = Product(
                          title: _editedProduct.title,
                          price: _editedProduct.price,
                          description: value,
                          imageUrl: _editedProduct.imageUrl,
                          id: _editedProduct.id,
                          isFavorite: _editedProduct.isFavorite,
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
                            // Can't use both initialValue and controller.
//                      initialValue: _initValues['imageUrl'],
                            decoration: InputDecoration(labelText: 'Image Url'),
                            keyboardType: TextInputType.url,
                            textInputAction: TextInputAction.done,
                            // Have this controller because I want this information before the form is submitted.
                            // This controller is updated only when the done button is pressed.
                            // That's why textInputAction: is set to TextInputAction.done
                            controller: _imageUrlController,
                            focusNode: _imageUrlFocusNode,

                            validator: (value) {
                              if (value.isEmpty) return 'Please enter an Image Url';

                              if (!value.startsWith('http') && !value.startsWith('https'))
                                return 'Please enter a valid Url';

//                        if (!value.endsWith('png') &&
//                            !value.endsWith('jpg') &&
//                            !value.endsWith('jpeg')) return 'Please enter a valid image Url';

                              return null;
                            },
                            // Creating a new Product each time onSaved is called since all the variables of a product are final
                            onSaved: (value) {
                              _editedProduct = Product(
                                title: _editedProduct.title,
                                price: _editedProduct.price,
                                description: _editedProduct.description,
                                imageUrl: value,
                                id: _editedProduct.id,
                                isFavorite: _editedProduct.isFavorite,
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
