<?php

return [
	'defaultMeta' => [
        'title' => ['defaults.seoTitle'],
        'description' => ['defaults.seoDescription'],
        'image' => ['defaults.seoImage']
    ],
	'defaultProfile' => 'standard',
    'fieldProfiles' => [
        'standard' => [
            'title' => ['seoTitle', 'title'],
            'description' => ['seoDescription', 'overview'],
            'image' => ['seoImage']
        ]
    ],

	'sitemapEnabled' => true,
	'sitemapLimit' => 100,
	'sitemapConfig' => [
	    'elements' => [
	        'pages' => ['changefreq' => 'monthly', 'priority' => 1],
	    ],
	]
];