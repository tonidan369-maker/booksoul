class Book {
  final String id, title, author, description, coverUrl; final List<String> tags, chapters, quotes; final int pages; final double rating;
  const Book({required this.id, required this.title, required this.author, required this.description, required this.coverUrl, required this.tags, required this.chapters, required this.quotes, required this.pages, required this.rating});
}

const demoBooks = <Book>[
  Book(id:'1',title:'عائد إلى حيفا',author:'غسان كنفاني',description:'رواية عن الذاكرة والاقتلاع والعودة، تفتح أسئلة الهوية والمسؤولية.',coverUrl:'https://images.unsplash.com/photo-1544947950-fa07a98d237f?w=600',tags:['رواية','فلسطين'],chapters:['الطريق إلى حيفا','في البيت القديم','المواجهة'],quotes:['أتعرفين ما هو الوطن يا صفية؟ الوطن هو ألا يحدث ذلك كله.'],pages:96,rating:4.8),
  Book(id:'2',title:'الأيام',author:'طه حسين',description:'سيرة أدبية خالدة ترسم رحلة العلم والإرادة من القرية إلى الجامعة.',coverUrl:'https://images.unsplash.com/photo-1512820790803-83ca734da794?w=600',tags:['سيرة','كلاسيكيات'],chapters:['في القرية','في الأزهر','في الجامعة'],quotes:['العلم لا يعطيك بعضه حتى تعطيه كلك.'],pages:320,rating:4.7),
  Book(id:'3',title:'موسم الهجرة إلى الشمال',author:'الطيب صالح',description:'رحلة سردية بين ضفتي النيل والغرب، عن الاغتراب والعودة.',coverUrl:'https://images.unsplash.com/photo-1495446815901-a7297e633e8d?w=600',tags:['رواية','عالمية'],chapters:['موسم العودة','مصطفى سعيد','القرية'],quotes:['إنني أسمع صوت الماء في النهر، كأنه يناديني.'],pages:184,rating:4.6),
  Book(id:'4',title:'رجال في الشمس',author:'غسان كنفاني',description:'ثلاثة رجال يبحثون عن حياة أفضل، في حكاية قصيرة شديدة الأثر.',coverUrl:'https://images.unsplash.com/photo-1519682337058-a94d519337bc?w=600',tags:['رواية','فلسطين'],chapters:['أبو قيس','أسعد','مروان'],quotes:['لماذا لم تدقوا جدران الخزان؟'],pages: eightyPages,rating:4.9),
  Book(id:'5',title:'حي بن يقظان',author:'ابن طفيل',description:'حكاية فلسفية عن المعرفة والفطرة واكتشاف العالم.',coverUrl:'https://images.unsplash.com/photo-1521587760476-6c12a4b040da?w=600',tags:['فلسفة','تراث'],chapters:['الجزيرة','المعرفة','الحقيقة'],quotes:['كلما اتسعت الرؤية ضاقت العبارة.'],pages:112,rating:4.5),
  Book(id:'6',title:'النبي',author:'جبران خليل جبران',description:'تأملات شعرية في الحب والعمل والحرية والموت.',coverUrl:'https://images.unsplash.com/photo-1543002588-bfa74002ed7e?w=600',tags:['شعر','تأملات'],chapters:['الحب','العمل','الحرية'],quotes:['الحب لا يعطي إلا ذاته ولا يأخذ إلا من ذاته.'],pages:128,rating:4.8),
];
const int eightyPages = 80;
