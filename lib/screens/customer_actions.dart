import 'package:flutter/material.dart';
import 'package:test_eshopping/screens/customers_list.dart';
import 'package:test_eshopping/screens/customers_page.dart';
import 'package:test_eshopping/utilsils/utilsils.dart';

class CustomerActionPage extends StatelessWidget {
  const CustomerActionPage({super.key});

  @override
  Widget build(BuildContext context) {
    double buttonWidth = ResponsiveUtils.getButtonWidth(context);
    double buttonHeight = ResponsiveUtils.getButtonHeight(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Customer Actions',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: screenWidth(context, dividedBy: 25).clamp(16, 25),
          ),
        ),
        toolbarHeight: screenHeight(context,dividedBy: 10),
        backgroundColor:  const Color(0xff00838F),
        iconTheme: const IconThemeData(
          color: Colors.white,
        ),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        decoration:  BoxDecoration(
          image: DecorationImage(
            image: const AssetImage("assets/images/customeractions.jpg"),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black.withOpacity(0.3), 
              BlendMode.darken, 
            ),
          ),
        ),
        child: Padding(
          padding: EdgeInsets.all(screenWidth(context, dividedBy: 25)),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: buttonWidth,
                  height: buttonHeight,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xff00838F), Color(0xff004D40)],
                    ),
                    borderRadius: BorderRadius.circular(buttonHeight * 0.3),
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const Customers()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                       elevation: 5,
                       shadowColor: Colors.black54,
                       
                      backgroundColor: Colors.transparent,
                      
                     
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(buttonHeight * 0.3),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Add New Customer',
                          style: TextStyle(
                            fontSize: buttonHeight * 0.25,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: buttonWidth * 0.05),
                        Icon(Icons.person_add, color: Colors.white, size: buttonHeight * 0.4),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: buttonHeight * 0.2),
                Container(
                   width: buttonWidth,
                  height: buttonHeight,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xff00838F), Color(0xff004D40)],
                    ),
                    borderRadius: BorderRadius.circular(buttonHeight * 0.3),
                  ),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => const CustomersList()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      elevation: 5,
                      backgroundColor: Colors.transparent,
                      
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(buttonHeight * 0.3),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Show All Customers',
                          style: TextStyle(
                            fontSize: buttonHeight * 0.25,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(width: buttonWidth * 0.05),
                        Icon(Icons.visibility_outlined,
                            color: Colors.white, size: buttonHeight * 0.4),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
