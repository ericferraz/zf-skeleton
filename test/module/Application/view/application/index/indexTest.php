<?php

namespace Application\Controller;

use \PHPUnit_Extensions_SeleniumTestCase;

class indexTest extends PHPUnit_Extensions_SeleniumTestCase
{

    public function setUp()
    {
        $this->setBrowser("*firefox");
        $this->setBrowserUrl("http://application");
    }
}
