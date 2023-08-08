	function enviar () {
		
		try {
			
			var firebaseConfig = {
				    apiKey: "AIzaSyDbEvJ-uSohK4fRQBEJC8XBT4SfayXMrKA",
					authDomain: "fletgo-8ce42.firebaseapp.com",
					databaseURL: "https://fletgo-8ce42.firebaseio.com",
					//projectId: "fletgo-8ce42",
					storageBucket: "fletgo-8ce42.appspot.com",
					messagingSenderId: "674811384115",
					//appId: "1:674811384115:web:ba7469c00d6cd1664aee46",
					//measurementId: "G-FGGLYL15R5"
			};	
			
			var mal = document.getElementById("email");
			var tel = document.getElementById("tel");
			var name = document.getElementById("name");
			var malval = mal.value;
			
			firebase.initializeApp(firebaseConfig);
			
			if(malval===""){
				
				alert("Rellenar los campos obligatorios");
				
			   }
			else
			   {
				   var db = firebase.database();
				   var newPostKey = firebase.database().ref().child('socios').push().key;
				   var refe = db.ref("socios/"+newPostKey);	
				   var userData = {
					   "Telefono" : tel.value,
					   "Correo" : mal.value,
					   "NombreCompleto" : name.value
				   }
				   
//				   alert(firebase.database().ref().child('socios').push().key);
//				   refe.push(userData);
				   refe.update(userData);
//				   refe.set(userData);
//				   alert(firebase.database().ref().child('socios').push().key);
				   
//				   var newPostKey = firebase.database().ref().child('socios').push().key;
				   

//				   var updates = {};
//				   updates['/socios/' + newPostKey] = userData;
//				   updates['/socios-posts/' + malval + '/' + newPostKey] = userData;
//				   
//				   return firebase.database().ref().update(updates);
				   
//				   var uid = Math.floor((Math.random() * 10) + 1);
//				   
//				    // A post entry.
//  					var postData = {
//					author: "username",
//					uid: "uid",
//					body: "body",
//					title: "title",
//					starCount: "0",
//					authorPic: "picture"
//					};
//				   
//					  // Get a key for a new Post.
//					  var newPostKey = firebase.database().ref().child('posts').push().key;
//
//					  // Write the new post's data simultaneously in the posts list and the user's post list.
//					  var updates = {};
//					  updates['/posts/' + newPostKey] = postData;
//					  updates['/user-posts/' + uid + '/' + newPostKey] = postData;
//
//					  return firebase.database().ref().update(updates);
				   
			   }
		}
		catch(e){
			alert(e);
		}
		
	   }

